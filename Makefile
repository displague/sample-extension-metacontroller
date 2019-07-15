DOCKER_ORG=displague

build:
	sed -i s/displague/${DOCKER_ORG}/ .registry/install.yaml # TODO(displague) this needs to change
	docker build . --tag ${DOCKER_ORG}/sample-extension-metacontroller
	docker push ${DOCKER_ORG}/sample-extension-metacontroller

clean:
	kubectl delete -k .
	kubectl delete -Rf .registry
