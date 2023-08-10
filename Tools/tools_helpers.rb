# frozen_string_literal: true

SYSTEM_BIN_PATH = '/usr/local/bin'
ROOT_DIR = `git rev-parse --show-toplevel | xargs echo -n`.freeze
WORKSPACE_ROOT = ROOT_DIR
SOURCE_ROOT = ENV['SRCROOT'] || Dir.pwd
PODS_ROOT = File.expand_path(File.join(ENV['PODS_ROOT'] || File.join(ROOT_DIR, 'Pods')))
TOOLS_ROOT = File.join(WORKSPACE_ROOT, 'Tools')
CONFIGS_ROOT = File.join(TOOLS_ROOT, 'Configs')

if File.exist?(File.join(ROOT_DIR, '.env'))
    File.foreach(File.join(ROOT_DIR, '.env')).each do |line|
        key, value = line.split('=')
        ENV[key] = value.strip if !key.nil? && !key.empty? && !line.nil?
    end
end
