require 'json'
require 'Pathname'

PROJECT_DIR = File.expand_path(File.dirname(__FILE__))
abort("Project directory contains one or more spaces – unable to continue.") if PROJECT_DIR.include?(' ')

namespace :ios_simulator_system_log do
    task :start do
        arguments_titles = "\n\t-subsystem,\n\t-category,\n\t-directory for logs (optional),\n\t-root directory (optional)"
        abort("Arguments should contain more than two arguments:#{arguments_titles}") if ARGV.length < 2
        subsystem = ARGV[1]
        category = ARGV[2]
        directory = ARGV[3] || 'Logs'
        project_folder_path = ARGV[4] || PROJECT_DIR

        loggingSimulators = Array.new

        loop do
            newDevices = booted_simulators - loggingSimulators
            loggingSimulators += newDevices

            Dir.mkdir(directory) unless File.exists?(directory)
            newDevices.each do |deviceId|
                fileName = Pathname.new(deviceId).sub_ext('.log')
                full_path = File.expand_path(fileName, directory)
                file = File.open(full_path, 'w')
                `xcrun simctl spawn #{deviceId} launchctl setenv PROJECT_FOLDER_PATH #{project_folder_path}`
                predicate = "'subsystem == \"#{subsystem}\" && category == \"#{category}\"'"
                command = "xcrun simctl spawn #{deviceId} log stream --level info --predicate #{predicate} --style json --type log"
                fork {
                  puts "Start streaming system log for device #{deviceId}"
                  exec(command, out: file)
                }
            end
            sleep 5
        end
    end

    def self.booted_simulators
        devicesInfo = `xcrun simctl list devices 'booted' -j`
        JSON.parse(devicesInfo)["devices"]
            .values
            .flatten
            .map { |device| device['udid'] }
    end
end