import pytest
from django.urls import reverse

@pytest.mark.django_db
def test_hello_page_renders(client):
    resp = client.get(reverse("hello"))
    assert resp.status_code == 200
    assert "Hello World" in resp.content.decode("utf-8")
