# Aplicativo client
app = angular.module("vanessador", ["ngRoute", "ngResource"])

# Asynchronously Bootstrapping AngularJS Applications with Server-Side Data
# https://blog.mariusschulz.com/2014/10/22/asynchronously-bootstrapping-angularjs-applications-with-server-side-data
initInjector = angular.injector(["ng"])

# AJAX
$http = initInjector.get("$http")
