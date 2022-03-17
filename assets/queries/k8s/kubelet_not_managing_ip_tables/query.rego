package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	command := "kubelet"

	common_lib.inArray(container.command, command)
	not k8sLib.hasFlag(container, "--make-iptables-util-chains=true")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("spec.command", []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--make-iptables-util-chains flag is true",
		"keyActualValue": "--make-iptables-util-chains= flag is false",
		"searchLine": common_lib.build_search_line(["spec", "command"], []),
	}
}
