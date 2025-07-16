# net-forward

Simple plugin that lest you create a local port listener on your personal machine
that redirects to an arbitrary TCP service that the Cluster can see. This is 
similar to `kubectl port-forward` without the restriction that forwarding can 
only use Pods or Services as destinations. 

This is intended to be flexible for people debugging network issues, testing 
whether objects are able to communicate with eachother, and from a security 
perspective, making it easier for pentesters to target other services on 
adjacent subnets from the comfort of their own machine. 

## Examples

Show help:

`kubectl net-forward -h`

Let the plugin prompt you for information:

`kubectl net-forward`

Make a local forwarder on port 9999 that redirects to https://10.24.0.1 in the cluster:

`kubectl net-forward -i 10.24.0.1 -p 443`

Make a local forwarder on port 8888 that redirects to http://169.254.169.254 from within the cluster:

`kubectl net-forward -i 169.254.169.254 -p 80 -l 8888`

Make a local forwarder inside the "testing" namespace and have it connect to an IP in the "default" namespace (e.g. 10.23.10.3):

`kubectl net-forward -n testing -i 10.23.10.3 -p 80`

Use net-forward with a custom image:

`kubectl net-forward --image alpine`
- custom container images must have the socat package installed
- you can also set the KUBECTL_NET_FORWARD_IMAGE env variable to avoid using the --image flag every time you run `kubectl net-forward` 

## Details

This works the same way as `port-forward`, when you run this, it will create a 
Pod running the alpine:socat image and then configure it to redirect to the service
of your choosing. 

## Future plans

- [ ] Rewrite into Go to support common cli stuff
- [ ] Suggest some useful endpoints to users (API endpoint, discovered services, metadata service)
- [ ] Add support for full proxy mode (like ssh -D)
- [ ] Support a service discovery mode (ie nmap)

## FAQ

**How is this different than port-forward**
`kubectl port-forward` requires that you give it a Pod or service and a port. Like `kubectl port-forward Pod/my-app 9999`
This restriction is useful when you're a cluster-admin but for security testing it's useful
to make arbitrary connection to other services that you've discovered. 

**Why would you want to use this?**
One example is the case where you wanted to verify whether the network controls you've setup
properly prevent a Pod in a namespace from accessing the Pod of another namespace. Maybe you've
configured a Network Policy that prevents Default/Pod/appA from accessing Secure/Pod/appB. 

For security folks, this lets you proxy communications to any host in the cluster for a variety
of things. I personnly like doing it because I have all of my favorite testing tools on my 
laptop and now can just point it another service in the cluster without having to tool up a Pod
or deploy a custom image. 


## Release workflow

Releases are created from git tags. Once a tag that starts with `v` is pushed,
GitHub Actions builds a tarball that contains the plugin script and attaches it
to the GitHub release. The version of the release is taken from the tag name.

To produce a new release:

1. Update the repository as needed and commit the changes.
2. Create a new tag following the `v<major>.<minor>.<patch>` pattern, e.g.
   `git tag v1.2.3`.
3. Push the tag to GitHub: `git push origin v1.2.3`.

The workflow packages `net-forward` into `net-forward_<version>.tar.gz` and
publishes it with the release. This artifact can be referenced from the
krew-index repository.
