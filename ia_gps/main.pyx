#! /usr/bin/env python
# cython: language_level=3
# distutils: language=c++

""" fuck gpsd """

import asyncio
from datetime             import datetime
import os
from types                import *
from typing               import Callable
from typing               import List
from typing               import Tuple
from typing               import ParamSpec
from typing               import Optional
from typing               import *

import dotenv
from fastapi              import FastAPI
from fastapi              import Response
from fastapi              import status
#from fastapi              import File
#from fastapi              import UploadFile
from structlog            import get_logger

from iarest.main          import start_server

logger = get_logger()

def get_app()->FastAPI:

	app                       :FastAPI = FastAPI()

	@app.get("/log")
	async def log(lat:float, longitude:float, time:datetime, s:float,)->Response:
		await logger.ainfo('latitude : %s', lat,)
		await logger.ainfo('longitude: %s', longitude,)
		await logger.ainfo('time     : %s', time,)
		await logger.ainfo('s        : %s', s,)

		result            :str     = 'success' # TODO
		return Response(content=result, media_type='text/plain', status_code=status.HTTP_200_OK)

	return app

def _main(
	host     :str,
	port     :int,
)->None:
	app:FastAPI = get_app()
	start_server(app=app, host=host, port=port,)

def main()->None:
	dotenv.load_dotenv()

	host           :str             =     os.getenv('HOST',        '0.0.0.0')
	port           :int             = int(os.getenv('PORT',        '2947'))

	_main(
		host     =host,
		port     =port,)

if __name__ == '__main__':
	main()

__author__:str = 'you.com' # NOQA
