require "Digest"

User.factory :peter do
  id 1001
  name "Peter"
  email "peter@example.com"
  password Digest::SHA1.hexdigest("Peter")
  api_access_key "xpeter"
  is_admin false
end

User.factory :pan do
  id 1002
  name "Pan"
  email "pan@example.com"
  password Digest::SHA1.hexdigest("Pan")
  api_access_key "xpan"
  is_admin false
end
