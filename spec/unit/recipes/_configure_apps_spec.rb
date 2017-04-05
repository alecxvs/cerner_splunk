
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'cerner_splunk::_configure_apps' do
  subject do
    runner = ChefSpec::SoloRunner.new(platform: 'redhat', version: '7.2') do |node|
      node.normal['splunk']['package']['type'] = 'splunk'
      node.normal['splunk']['apps'] = apps
    end
    runner.converge('cerner_splunk::_restart_prep', described_recipe)
  end

  let(:apps) do
    {
      'test_app' => {
        'files' => {
          'app.conf' => {
            'ui' => {
              'is_visible' => '1',
              'label' => 'Test App'
            }
          }
        },
        'lookups' => {
          'index-owners.csv' => 'http://33.33.33.33:5000/lookups/index-owners.csv'
        }
      }
    }
  end

  it { is_expected.to_not be_nil }

  it 'installs the app with the expected attributes' do
    expected_attributes = {
      lookups: {
        'index-owners.csv' => 'http://33.33.33.33:5000/lookups/index-owners.csv'
      },
      files: {
        'app.conf' => {
          'ui' => {
            'is_visible' => '1',
            'label' => 'Test App'
          }
        }
      }
    }
    expect(subject).to install_splunk_app('test_app').with(expected_attributes)
  end

  context 'when remove is set to true' do
    let(:apps) do
      {
        'test_app' => {
          'remove' => true
        }
      }
    end

    it 'removes the app' do
      expect(subject).to uninstall_splunk_app('test_app')
    end
  end
end
