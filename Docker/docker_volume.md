## How to upload data to docker volume

```bash
docker run --rm -i --user="0:0" -v sample-data:/local/notesdata \
  --entrypoint "/bin/bash" volt-docker:V1101-1.0.0.11 \
  -c "cd /local/notesdata; tar xjf - <&0; chown -R notes:notes /local/notesdata" < renovations-data.tbz2
  ```