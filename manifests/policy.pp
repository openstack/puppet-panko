# == Class: panko::policy
#
# Configure the panko policies
#
# === Parameters
#
# [*enforce_scope*]
#  (Optional) Whether or not to enforce scope when evaluating policies.
#  Defaults to $::os_service_default.
#
# [*policies*]
#   (Optional) Set of policies to configure for panko
#   Example :
#     {
#       'panko-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'panko-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the panko policy.yaml file
#   Defaults to /etc/panko/policy.yaml
#
class panko::policy (
  $enforce_scope = $::os_service_default,
  $policies      = {},
  $policy_path   = '/etc/panko/policy.yaml',
) {

  include panko::deps
  include panko::params

  validate_legacy(Hash, 'validate_hash', $policies)

  Openstacklib::Policy::Base {
    file_path   => $policy_path,
    file_user   => 'root',
    file_group  => $::panko::params::group,
    file_format => 'yaml',
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'panko_config':
    enforce_scope => $enforce_scope,
    policy_file   => $policy_path
  }

}
