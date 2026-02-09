import logging
from django.http import HttpRequest, HttpResponse
from django.shortcuts import render

logger = logging.getLogger(__name__)

def hello(request: HttpRequest) -> HttpResponse:
    # Debug evidence #1: log output
    logger.info("hello() route hit path=%s", request.path)

    # Debug evidence #2 (optional): a breakpoint you can hit with debugpy/VS Code
    # Put a VS Code breakpoint on the next line, or uncomment breakpoint():
    # breakpoint()

    return render(request, "hello.html", {"title": "Hello World"})
