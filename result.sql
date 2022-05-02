-- __/\\\\\\\\\\\__/\\\\\_____/\\\__/\\\\\\\\\\\\\\\_____/\\\\\_________/\\\\\\\\\_________/\\\\\\\________/\\\\\\\________/\\\\\\\________/\\\\\\\\\\________________/\\\\\\\\\_______/\\\\\\\\\_____        
--  _\/////\\\///__\/\\\\\\___\/\\\_\/\\\///////////____/\\\///\\\_____/\\\///////\\\_____/\\\/////\\\____/\\\/////\\\____/\\\/////\\\____/\\\///////\\\_____________/\\\\\\\\\\\\\___/\\\///////\\\___       
--   _____\/\\\_____\/\\\/\\\__\/\\\_\/\\\_____________/\\\/__\///\\\__\///______\//\\\___/\\\____\//\\\__/\\\____\//\\\__/\\\____\//\\\__\///______/\\\_____________/\\\/////////\\\_\///______\//\\\__      
--    _____\/\\\_____\/\\\//\\\_\/\\\_\/\\\\\\\\\\\____/\\\______\//\\\___________/\\\/___\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\_________/\\\//_____________\/\\\_______\/\\\___________/\\\/___     
--     _____\/\\\_____\/\\\\//\\\\/\\\_\/\\\///////____\/\\\_______\/\\\________/\\\//_____\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\________\////\\\____________\/\\\\\\\\\\\\\\\________/\\\//_____    
--      _____\/\\\_____\/\\\_\//\\\/\\\_\/\\\___________\//\\\______/\\\______/\\\//________\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\___________\//\\\___________\/\\\/////////\\\_____/\\\//________   
--       _____\/\\\_____\/\\\__\//\\\\\\_\/\\\____________\///\\\__/\\\______/\\\/___________\//\\\____/\\\__\//\\\____/\\\__\//\\\____/\\\___/\\\______/\\\____________\/\\\_______\/\\\___/\\\/___________  
--        __/\\\\\\\\\\\_\/\\\___\//\\\\\_\/\\\______________\///\\\\\/______/\\\\\\\\\\\\\\\__\///\\\\\\\/____\///\\\\\\\/____\///\\\\\\\/___\///\\\\\\\\\/_____________\/\\\_______\/\\\__/\\\\\\\\\\\\\\\_ 
--         _\///////////__\///_____\/////__\///_________________\/////_______\///////////////_____\///////________\///////________\///////_______\/////////_______________\///________\///__\///////////////__

-- Your Name: Hogi Kwak
-- Your Student Number: 1235667
-- By submitting, you declare that this work was completed entirely by yourself.

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q1

SELECT user1 AS userID
FROM friendof
WHERE WhenRejected IS NULL AND WhenConfirmed IS NULL AND WhenUnfriended IS NULL;




-- END Q1
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2

SELECT id AS forumId, topic, COUNT(User) AS numSubs
FROM  forum INNER JOIN subscribe ON forum.id = subscribe.Forum
GROUP BY Forum;



-- END Q2
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3

SELECT
	post.forum as 'forumId',
    post.id as 'postId',
    post.whenposted as 'whenPosted'
FROM post
WHERE post.forum IS NOT NULL
ORDER BY post.whenposted DESC
LIMIT 1;



-- END Q3
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q4

SELECT following as 'userID of followed', follower as 'usedId of follower'
FROM following INNER JOIN user ON following.Follower = user.Id
ORDER BY following ASC;


-- END Q4
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q5

SELECT admin.Id AS adminId, forum.Id AS forumId, COUNT(upvote.User) AS numberOfUpvotesInForum
FROM forum INNER JOIN  post ON post.Forum = forum.Id
INNER JOIN admin ON admin.Id = forum.CreatedBy
INNER JOIN upvote ON post.Id = upvote.Post
GROUP BY adminId, forumId
ORDER BY numberOfUpvotesInForum DESC
LIMIT 1;



-- END Q5
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q6

SELECT DISTINCT Id AS userId, username
FROM user
LEFT JOIN friendof AS User1 ON User1.user1 = user.Id
LEFT JOIN friendof AS User2 ON User2.user2 = user.Id
where User1.user1 IS NULL 
AND User2.user2 IS NULL
AND Id NOT IN
		(SELECT DISTINCT Follower
		 FROM following)
ORDER BY user.Id ASC;


-- END Q6
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q7

SELECT PostNum.userId AS userId, LikeNum.LikeNum / PostNum.PostNum AS avgUpvotes 
FROM (SELECT user.Id AS userId, COUNT(post.Id) AS PostNum
	  FROM user INNER JOIN post ON user.Id = post.PostedBy
      GROUP BY user.Id) AS PostNum
      INNER JOIN (SELECT user.Id AS userId, COUNT(upvote.Post) AS LikeNum
				  FROM user LEFT JOIN post ON user.Id = post.PostedBy
                  LEFT JOIN upvote ON post.Id = upvote.Post
                  GROUP BY user.Id) AS LikeNum
	  ON PostNum.userId = LikeNum.UserId
WHERE LikeNum.LikeNum / PostNum.PostNum >= 1;


-- END Q7
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q8

SELECT post.Id AS PostOrCommentId
FROM post
WHERE post.Id IN (SELECT child.Id
				  FROM post AS parent INNER JOIN post AS child 
                  ON parent.Id = child.ParentPost
				  WHERE (SELECT COUNT(upvote.Post) 
                         FROM upvote
                         WHERE upvote.Post = parent.Id) < (SELECT COUNT(upvote.Post) 
                                                          FROM upvote 
                                                          WHERE upvote.Post = child.Id))
ORDER BY post.Id;


-- END Q8
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q9

SELECT generaluser.Id AS userID
FROM generaluser
WHERE generaluser.Id IN (SELECT friendof.user2
                         FROM friendof INNER JOIN post ON friendof.user1 = post.PostedBy
                         INNER JOIN upvote ON upvote.Post = post.Id
                         WHERE friendof.WhenConfirmed IS NOT NULL AND friendof.WhenRejected IS NULL AND friendof.WhenUnfriended IS NULL)
OR generaluser.Id IN (SELECT upvote.User
						 FROM post INNER JOIN admin ON post.PostedBy = admin.Id
                         INNER JOIN upvote ON post.Id = upvote.Post);


-- END Q9
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q10

SELECT admin.Id AS adminId, forum.Id AS forumId, COUNT(subscribe.User) AS numSubscriptions
FROM admin LEFT JOIN forum ON admin.Id = forum.CreatedBy
    LEFT JOIN subscribe ON subscribe.Forum = forum.Id
GROUP BY adminId, forum.Id
Having  forum.Id IS NULL
OR COUNT(subscribe.User) >= 1;


SELECT admin.Id AS adminId, forum.Id AS forumId, SUM(numSubscriptions) 
FROM (SELECT admin.Id AS adminId, forum.id AS forumId, COUNT(subscribe.User) AS numSubscriptions
        FROM admin LEFT JOIN forum ON admin.Id = forum.CreatedBy
        LEFT JOIN subscribe ON subscribe.Forum = forum.Id
        GROUP BY adminId, forum.Id) AS total_subscriptions
GROUP BY forum.Id;



-- END Q10
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- END OF ASSIGNMENT Do not write below this line