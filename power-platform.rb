transform "PowerPlatformToolInstaller@2" do |item|
    {
        "uses" => "microsoft/powerplatform-actions/actions-install@v1"
    }
end

transform "PowerPlatformWhoAmi@2" do |item|
    secretPrefix = "${{secrets." + item["PowerPlatformSPN"].upcase.sub('-','_')
    {
        "uses" => "microsoft/powerplatform-actions/who-am-i@v1",
        "with" => {
            "environment-url" => '${{secrets.ENVIRONMENT_URL}}',
            "tenant-id" => secretPrefix + "_TENANT_ID}}",
            "app-id" => secretPrefix + "_APP_ID}}",
            "client-secret" => secretPrefix + "_CLIENT_SECRET}}"
        }
    }
end