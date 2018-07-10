#!/bin/bash

# https://docs.cloudify.co/staging/next/working_with/manager/external-authentication/
sudo mkdir -p /opt/manager/resources/authenticators/

echo '
from cloudify_premium.authentication.auth_base import AuthBase, UserData


class MyAuthentication(AuthBase):

    def _authenticate_request(self, request):
        auth = request.authorization
        if auth and auth.username == "meme":
            return UserData(auth.username)
        return None


def configure(self, logger):
   """
   Set the object instance.
   Being called after the configuration is loaded
   """
   self.logger = logger
   return self


def can_handle_auth_request(self, request):
   """
   Validate that this authenticator can handle auth process,
   for given request
   """
   return request.authorization


my_auth = MyAuthentication()
configure = my_auth.configure
' | sudo tee /opt/manager/resources/authenticators/authentication.py

sudo chown cfyuser:cfyuser -R /opt/manager/resources/authenticators/
