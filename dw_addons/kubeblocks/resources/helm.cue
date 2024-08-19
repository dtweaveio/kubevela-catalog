// We put Components in resources directory.
// References:
// - https://kubevela.net/docs/end-user/components/references
// - https://kubevela.net/docs/platform-engineers/addon/intro#resources-directoryoptional
package main

kubeblocksCharts: {
	name: "kubeblocks"
	type: "helm"
	properties: {
		repoType: "helm"
		url:      "https://charts.dtweave.com/kubevela"
		chart:    "kubeblocks"
		version:  "0.9.0"
	}
}