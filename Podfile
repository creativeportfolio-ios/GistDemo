# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['AlamofireOauth2'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.1'
            end
        end
    end
end

target 'GistDemo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GistDemo
  inhibit_all_warnings!
  # Pods for GistDemo
    pod 'AlamofireObjectMapper'
    pod 'BrightFutures'
    pod 'RappleProgressHUD'
    pod 'AlamofireOauth2'
    pod 'SDWebImage'
    pod 'IQKeyboardManager'

  target 'GistDemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GistDemoUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
