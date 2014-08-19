#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2008 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

provides "hostname", "fqdn"

hostname from("hostname -s")
begin
  ourfqdn = from("hostname --fqdn")
  # Sometimes... very rarely, but sometimes, 'hostname --fqdn' falsely
  # returns a blank string. WTF.
  if ourfqdn.nil? || ourfqdn.empty?
    Ohai::Log.debug("hostname --fqdn returned an empty string, retrying " +
                    "once.")
    ourfqdn = from("hostname --fqdn")
  end

  if ourfqdn.nil? || ourfqdn.empty?
    Ohai::Log.debug("hostname --fqdn returned an empty string twice and " +
                    "will not be set.")
  else
    fqdn ourfqdn
  end
rescue
  Ohai::Log.debug("hostname --fqdn returned an error, probably no domain set")
end