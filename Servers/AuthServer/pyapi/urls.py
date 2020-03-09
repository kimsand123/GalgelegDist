from django.urls import path, re_path, include

from . import views

# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.

urlpatterns = [
    path('', views.welcome),
    path('auth/', views.login),
    re_path(r'$', views.bad_request),
]
