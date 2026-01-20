local http = require "resty.http"
local cjson = require "cjson"

return function()
    local client = http.new()

    local res, err = client:request_uri(
        "http://169.254.169.254/metadata/identity/oauth2/token",
        {
            method = "GET",
            headers = { ["Metadata"] = "true" },
            query = {
                resource = "https://storage.azure.com/",
                ["api-version"] = "2019-08-01"
            }
        }
    )

    if not res then
        ngx.log(ngx.ERR, "Failed to get token: ", err)
        return nil
    end

    local body = cjson.decode(res.body)
    if not body or not body.access_token then
        ngx.log(ngx.ERR, "Token parse failed: ", res.body)
        return nil
    end

    return body.access_token
end