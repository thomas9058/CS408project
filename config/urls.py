from django.contrib import admin
from django.urls import path
from pages.views import hello

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", hello, name="hello"),
]
