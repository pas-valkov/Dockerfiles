Test task for creating a docker image

Ñonditions:
- Base image: Ubuntu 18:04
- One layer for one program
- Every program has to be instaled in directory /SOFT/

To install:
- last version of samtools with maximum plugins (included libdeflate)
- biobambam**
-------------------------------------

To run:
docker run -it <your_image>

This Dockerfile does not install biobambam and one plugin for samtools, but main idea is clear