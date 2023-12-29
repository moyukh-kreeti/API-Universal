module DocumentsHelper
  AWS_ACCESS_KEY_ID = Rails.application.credentials.aws[:access_key_id]
  AWS_SECRET_ACCESS_KEY = Rails.application.credentials.aws[:secret_access_key]
  AWS_REGION = Rails.application.credentials.aws[:region]
  BUCKET_NAME = Rails.application.credentials.aws[:bucket]
  AWS_SERVICE = 's3'

  def make_s3_request(http_method, object_key, request_parameters, payload, content_type)
    endpoint = "https://#{BUCKET_NAME}.s3.#{AWS_REGION}.amazonaws.com/#{object_key}"
    t = Time.now.utc
    amz_date = t.strftime('%Y%m%dT%H%M%SZ')
    datestamp = t.strftime('%Y%m%d')
    payload_hash = OpenSSL::Digest::SHA256.hexdigest(payload)

    canonical_headers = "host:#{BUCKET_NAME}.s3.#{AWS_REGION}.amazonaws.com\nx-amz-content-sha256:#{payload_hash}\nx-amz-date:#{amz_date}\n"
    canonical_request = "#{http_method}\n/#{object_key}\n#{request_parameters}\n#{canonical_headers}\nhost;x-amz-content-sha256;x-amz-date\n#{payload_hash}"
    credential_scope = "#{datestamp}/#{AWS_REGION}/#{AWS_SERVICE}/aws4_request"
    string_to_sign = "AWS4-HMAC-SHA256\n#{amz_date}\n#{credential_scope}\n#{OpenSSL::Digest::SHA256.hexdigest(canonical_request)}"
    k_date = OpenSSL::HMAC.digest('sha256', "AWS4#{AWS_SECRET_ACCESS_KEY}", datestamp)
    k_region = OpenSSL::HMAC.digest('sha256', k_date, AWS_REGION)
    k_service = OpenSSL::HMAC.digest('sha256', k_region, AWS_SERVICE)
    k_signing = OpenSSL::HMAC.digest('sha256', k_service, 'aws4_request')
    signature = OpenSSL::HMAC.hexdigest('sha256', k_signing, string_to_sign)
    authorization_header = "AWS4-HMAC-SHA256 Credential=#{AWS_ACCESS_KEY_ID}/#{credential_scope}, SignedHeaders=host;x-amz-content-sha256;x-amz-date, Signature=#{signature}"
    amz_headers = {
      'Authorization' => authorization_header,
      'x-amz-content-sha256' => payload_hash,
      'x-amz-date' => amz_date,
    }
    if http_method == 'PUT' 
      amz_headers['Content-Type'] = content_type
    end
    response = HTTParty.send(http_method.downcase, endpoint, body: payload, headers: amz_headers)
    response
  end

  def getObjectFromS3(filename)
    make_s3_request('GET', filename, '', '', '')
  end

  def uploadToS3(file, key)
    make_s3_request('PUT', key, '', file.read, file.content_type)
  end

  def destroyObjectFromS3(filename)
    make_s3_request('DELETE', filename, '', '', '')
  end
end
