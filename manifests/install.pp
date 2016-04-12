class gerrit::install {

  if $gerrit::manage_user {
    contain ::gerrit::install::user
  }

  # Config is seeded before installation so the post-install hook uses it directly
  # Note that a 'gerrit' user must already exist to assign file ownership
  contain ::gerrit::config

  if $gerrit::manage_repo {
    contain ::gerrit::install::repo
  }

  if $gerrit::manage_package {
    contain ::gerrit::install::package
  }

}