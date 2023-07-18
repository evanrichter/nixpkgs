{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, nix-update-script
, Security
, SystemConfiguration
, protobuf
}:

let
  pname = "imap-server";
  version = "0.3.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PGVXEb/2Hwcs5nJoUzVBXEKPMd97c5nqw4gzzrzdvNM=";
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hyper-util-0.0.0" = "sha256-wGtB6hUjIOKR7UZJrX9ve4x4/7TDQuSPG0Sq9VyW7iI=";
      "jmap-client-0.3.0" = "sha256-GNqSPygiVq5Z9y8Kfhzacq3lTIEg2o4UxzOMDbBO7xY=";
      "mail-auth-0.3.2" = "sha256-Diu1AruVg5g/GN4pBm6enjUFTJ4H5cuLtwFk/fQghUw=";
      "mail-builder-0.3.0" = "sha256-0o/fV7ZKiRKeitBBt8yOM/2nXIEgOGSMEMaBj+3i7Kw=";
      "mail-parser-0.8.2" = "sha256-XvKEgzQ+HDoLI16CmqE/RRgApg0q9Au9sqOOEpZz6W0=";
      "mail-send-0.4.0" = "sha256-bMPI871hBj/RvrW4kESGS9XzfnkSo8r2/9uUwgE12EU=";
      "sieve-rs-0.3.1" = "sha256-0LE98L7JEc6FObygIsln4Enw2kx8FnLotJ/fXGpc4E8=";
      "smtp-proto-0.1.1" = "sha256-HhKZQHQv3tMEfRZgCoAtyxVzwHbcB4FSjKlMoU1PkHg=";
    };
  };

  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  buildInputs = lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Stalwart IMAP server";
    homepage = "https://stalw.art/imap";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.all;
  };
}
