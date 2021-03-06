SET SCHEMA FN000;

CREATE FUNCTION FN000.GET_NUMBER_OF_LIKES(V_POST_ID INTEGER)
  RETURNS INTEGER
  RETURN
  SELECT COUNT(*)
  FROM LIKES
  WHERE POST_ID = V_POST_ID;

CREATE FUNCTION FN000.GET_NUMBER_OF_COMMENTS(V_POST_ID INTEGER)
  RETURNS INTEGER
  RETURN
  SELECT COUNT(*)
  FROM COMMENTS
  WHERE POST_ID = V_POST_ID;


CREATE FUNCTION FN000.GET_NUMBER_OF_FRIENDS(V_USER_ID INTEGER)
  RETURNS INTEGER
  RETURN
  SELECT COUNT(*)
  FROM FRIENDSHIPS
  WHERE USER1_ID = V_USER_ID
    OR USER2_ID = V_USER_ID;

