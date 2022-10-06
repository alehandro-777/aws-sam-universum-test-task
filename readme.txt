git rm --cached directory
git add directory

echo "# universium-imdb-test-task" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/alehandro-777/aws-sam-universum-test-task.git
git push -u origin main


…or push an existing repository from the command line
git remote add origin https://github.com/alehandro-777/aws-sam-universum-test-task.git
git branch -M main
git push -u origin main

https://aaoha4vxy0.execute-api.us-east-1.amazonaws.com/Prod/movies?page=0&size=30&director=we&genre=com

https://aaoha4vxy0.execute-api.us-east-1.amazonaws.com/Prod/actor_stats/1234