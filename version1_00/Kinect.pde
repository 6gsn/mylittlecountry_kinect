
import SimpleOpenNI.*;
SimpleOpenNI kinect;

PVector rightHand;
PVector leftHand;

boolean setupKinect() {
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.setMirror(true);
  
  rightHand = new PVector();
  leftHand = new PVector();
  
  convertedRightHand = new PVector();
  convertedLeftHand = new PVector();


  // turn on user tracking
  kinect.enableUser();
  
  return true;
}


void updateKinect() {
  
  kinect.update();

  // make a vector of ints to store the list of users
  IntVector userList = new IntVector();
  
  // write the list of detected users
  // into our vector
  kinect.getUsers(userList);
  
  // if we found any users
  if (userList.size() > 0) {
    // get the first user
    int userId = userList.get(0);
    
    // if we’re successfully calibrated
    if ( kinect.isTrackingSkeleton(userId)) {
      // make a vector to store the left hand
      
      int rightRestx = 0;
      int rightResty = 0;
      
      int leftRestx = 0;
      int leftResty = 0;

      
      // put the position of the left hand into that vector
      float confidenceRight = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,rightHand);
      float confidenceLeft = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,leftHand);
      
      // convert the detected hand position
      // to "projective" coordinates
      
      kinect.convertRealWorldToProjective(rightHand, convertedRightHand);
      kinect.convertRealWorldToProjective(leftHand, convertedLeftHand);
      
      
      }
    }
}

// -----------------------------------------------------------------
// SimpleOpenNI user events

void onNewUser(SimpleOpenNI curContext,int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  kinect.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext,int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext,int userId)
{
  println("onVisibleUser - userId: " + userId);
}


// -----------------------------------------------------------------
