ratings = LOAD '/user/maria_dev/ml-100k/u.data' AS (userID:int, movieID:int, rating:int, ratingTime:int);
metadata = LOAD '/user/maria_dev/ml-100k/u.item' USING PigStorage('|')
	AS (movieID:int, movieTitle:chararray, releaseDate:chararray, videoRealese:chararray, imdblink:chararray);
   
nameLookup = FOREACH metadata GENERATE movieID, movieTitle;
   
groupratings = GROUP ratings BY movieID;
avgRatings = FOREACH groupratings GENERATE group as movieID, AVG(ratings.rating) as avgRating,COUNT(ratings.rating) AS numratings;
badmovies = FILTER avgRatings BY avgRating < 2.0;
namedbadmovies = JOIN badmovies BY movieID, nameLookup BY movieID;
finalresult= FOREACH namedbadmovies GENERATE nameLookup::movieTitle AS moviename, badmovies::avgRating AS avgRating, badmovies::numratings AS numratings;
finalresultsorted = ORDER finalresult BY numratings DESC;
DUMP finalresultsorted;
