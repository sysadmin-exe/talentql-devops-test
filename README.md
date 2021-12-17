# TERRAFORM CICD

The pipeline here is set to do and plan and resource connectivity test on PR to Master. If plan or test fails the build in the PR fails and code in PR should be reviewed. 

Tried to use terratest but there were some issues with GOPATH not found in the VM used for the build in Travis CI. HAd to go on to use a bash script which gets the IP address of the newly deployed Apache server from Terraform output and then runs a curl on the address. If a status 200 is gotten, then the VM is considered as up, otherwise the test script exits with 1 and the pipeline fails.
