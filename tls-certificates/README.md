# Adding TLS certificates

In order to add a TLS certificate from LetsEncrypt:

1. Assure that you have a working nginx-ingress (see directory nginx-ingress)
2. Assure that you have installed cert-manager (see directory cert-manager)
3. Assure that you have a directory per application (i.e. `openfaas`) where you want to enable TLS

## Configure cert-manager

In additional to the controller installed in the previous step, we must also configure an "Issuer" before cert-manager can create certificates for our services. For convenience we will create an Issuer for both Let's Encrypt's production API and their staging API. The staging API has much higher rate limits. We will use it to issue a test certificate before switching over to a production certificate if everything works as expected.

In each directory (i.e. `openfaas`) the file should be edited to:

* Replace `<your-email-here>` with the contact email that will be shown with the TLS certificate.
* Replace `<application-namespace>` with the namespace of the application that you want to add the certificate.


    # letsencrypt-issuer.yaml
    apiVersion: cert-manager.io/v1alpha2
    kind: Issuer
    metadata:
      name: letsencrypt-staging
      namespace: <application-namespace>
    spec:
      acme:
        # You must replace this email address with your own.
        # Let's Encrypt will use this to contact you about expiring
        # certificates, and issues related to your account.
        email: <your-email-here>
        server: https://acme-staging-v02.api.letsencrypt.org/directory
        privateKeySecretRef:
        # Secret resource used to store the account's private key.
          name: example-issuer-account-key
        # Add a single challenge solver, HTTP01 using nginx
        solvers:
        - http01:
            ingress:
              class: nginx
    ---
    apiVersion: cert-manager.io/v1alpha2
    kind: Issuer
    metadata:
      name: letsencrypt-prod
      namespace: <application-namespace>
    spec:
      acme:
        # You must replace this email address with your own.
        # Let's Encrypt will use this to contact you about expiring
        # certificates, and issues related to your account.
        email: <your-email-here>
        server: https://acme-v02.api.letsencrypt.org/directory
        privateKeySecretRef:
        # Secret resource used to store the account's private key.
          name: example-issuer-account-key
        # Add a single challenge solver, HTTP01 using nginx
        solvers:
        - http01:
            ingress:
              class: nginx

Normally you would run `$ kubectl apply -f letsencrypt-issuer.yaml` to apply the above script.

In order to automate the deployment and destroy of the Issuer, we separated the this operation and for each application you should run the `start` script in order to install the two Issuers (one for staging and one for production).

This will allow cert-manager to automatically provision Certificates just in the application's namespace.

Since we are defining two Issuers, one for staging and one for production, you need to run the installation of `openfaas` using the file desired values.