### Prerequisite

For now, make sure metacontroller is installed first.

https://metacontroller.app/guide/install/#install-metacontroller

```sh
# Create metacontroller namespace.
kubectl create namespace metacontroller
# Create metacontroller service account and role/binding.
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/metacontroller/master/manifests/metacontroller-rbac.yaml
# Create CRDs for Metacontroller APIs, and the Metacontroller StatefulSet.
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/metacontroller/master/manifests/metacontroller.yaml
```

### Create the HelloWorld Metacontroller Extension

Create the extension.  The files in this repository will be bundled into a docker image.  The sync.py script, controller.yaml, and webhook.yaml are taken directly from <https://metacontroller.app/guide/create/> with only cosmetic changes.

```sh
DOCKER_ORG=displague
sed -i s/displague/$DOCKER_ORG/ .registry/install.yaml # TODO(displague) this needs to change
docker build . --tag $DOCKER_ORG/sample-extension-metacontroller
docker push
```

The dockerfile is composed of the Crossplane metadata necessary to be considered an extension, but it also includes a script (`install.sh`, the `CMD` of this docker image) to handle installation, updating, and removal of the Extension life-cycle controller.  Arguments may be supplied to this command (in the future) to denote which version of the controller to deploy.  While not implemented currently, these arguments would be provided in `install.yaml`.

### Install the HelloWorld Extension

Then creates a CR for a the extension to be installed.

```sh
cat > install-the-extension.yaml <<EOS
apiVersion: extensions.crossplane.io/v1alpha1
kind: ExtensionRequest
metadata:
  name: sample-extension-metacontroller-from-package
spec:
  # source: localhost
  package: $DOCKER_ORG/sample-extension-metacontroller
EOS

kubectl apply -f install-the-extension.yaml
```

The extension should be installed now.  The extension manager has invoked the `install```

The extension should be installed now.  The extension manager has invoked the `install.yaml` which is a Kubernetes `Job` that runs our extension container (`install.sh`) with the `prepare` argument.

This installs our custom metacontroller controller and webhook.

### Creating a HelloWorld instance

We can now invoke the metacontroller based extension by 
```
cat > deploy-a-resource-the-extension-handles.yaml <<EOS
# This is an example.yaml file which may be included in documentation
apiVersion: sample.crossplane.io/v1
kind: HelloWorld
metadata:
  name: $DOCKER_ORG
spec:
  who: $DOCKER_ORG
EOS

kubectl apply -f deploy-a-resource-the-extension-handles.yaml
```


