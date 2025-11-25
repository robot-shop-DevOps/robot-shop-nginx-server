local http = require "resty.http"

return function()
    local client = http.new()

    local res, err = client:request_uri(
        "http://169.254.169.254/metadata/identity/oauth2/token",
        {
            method = "GET",
            headers = { ["Metadata"] = "true" },
            query = {
                resource = "https://storage.azure.com/"
            }
        }
    )

    if not res then
        return "Error: " .. (err or "unknown")
    end

    return res.body
end