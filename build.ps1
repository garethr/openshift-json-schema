# This script uses openapi2jsonschema to generate a set of JSON schemas for
# the specified Kubernetes versions in three different flavours:
#
#   X.Y.Z - URL referenced based on the specified GitHub repository
#   X.Y.Z-standalone - de-referenced schemas, more useful as standalone documents
#   X.Y.Z-local - relative references, useful to avoid the network dependency

$repo="garethr/openshift-json-schema"

$arr = @("master",
         "v3.6.0",
         "v1.5.1",
         "v1.5.0")

foreach($version in $arr) {
    $schema="https://raw.githubusercontent.com/openshift/origin/${version}/api/swagger-spec/openshift-openapi-spec.json"
    $prefix="https://raw.githubusercontent.com/${repo}/master/${version}/_definitions.json"

    docker run --rm -v ${PWD}:/out garethr/openapi2jsonschema -o "$version-standalone-strict" --kubernetes --stand-alone --strict "$schema"
    docker run --rm -v ${PWD}:/out garethr/openapi2jsonschema -o "$version-standalone" --kubernetes --stand-alone "$schema"
    docker run --rm -v ${PWD}:/out garethr/openapi2jsonschema -o "$version-local" --kubernetes "$schema"
    docker run --rm -v ${PWD}:/out garethr/openapi2jsonschema -o "$version" --kubernetes --prefix "$prefix" "$schema"
    dos2unix.exe "$version-standalone-strict/*"
    dos2unix.exe "$version-standalone/*"
    dos2unix.exe "$version-local/*"
    dos2unix.exe "$version/*"
}
