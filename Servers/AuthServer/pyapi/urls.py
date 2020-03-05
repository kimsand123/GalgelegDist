from django.urls import include, path
from . import views

# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns = [
    path('', views.hero_list),
    path('<str:name>', views.hero_detail),
    path('auth/', views.login),
    path('api-auth/', include('rest_framework.urls', namespace='rest_framework')),
]
