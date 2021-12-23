FROM python:3.9.9-buster

#make a directory as a working directory

WORKDIR /app

#install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

#copy source code

COPY /app .

#run the application

CMD ["python","index.py"]