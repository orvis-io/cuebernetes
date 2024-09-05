module: "cuebernetes.orvis.io/timoni"
language: {
	version: "v0.9.2"
}
source: {
	kind: "self"
}
deps: {
	"helm.toolkit.fluxcd.io@v0": {
		v:       "v0.0.2"
		default: true
	}
	"k8s.io@v0": {
		v:       "v0.0.1"
		default: true
	}
	"source.toolkit.fluxcd.io@v0": {
		v:       "v0.0.2"
		default: true
	}
	"timoni.sh@v0": {
		v:       "v0.0.2"
		default: true
	}
}
