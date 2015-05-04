requires "B::Hooks::EndOfScope" => "0";
requires "Moose" => "0.94";
requires "Moose::Exporter" => "0";
requires "Moose::Role" => "0";
requires "Moose::Util::MetaRole" => "0";
requires "namespace::autoclean" => "0.12";
requires "perl" => "5.006";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "File::Spec" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Test::CheckDeps" => "0.010";
  requires "Test::Moose" => "0";
  requires "Test::More" => "0.94";
  requires "overload" => "0";
  requires "perl" => "5.006";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "perl" => "5.006";
};

on 'develop' => sub {
  requires "Dist::Zilla::PluginBundle::RSRCHBOY" => "0.060";
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::EOL" => "0";
  requires "Test::More" => "0.88";
  requires "Test::NoTabs" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Pod::Coverage" => "1.08";
  requires "Test::Spelling" => "0.12";
  requires "Test::Synopsis" => "0";
  requires "version" => "0.9901";
};
