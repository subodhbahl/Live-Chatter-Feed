public class GNationLiveController {
    
   //Properties
   public boolean noFeeds {get; set;}
   public Map <String, String> MapIdPhotoUrl = new Map <String, String>();
   List <User> listUser;
   List <FeedItem> ChatterPosts;
   String GNationGroup;
   GNationLive__c GNationLive;
   Integer RefreshTime;
   String instance;
   String ChatterImageAttachmentURL2 = '.content.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB120BY90&versionId=';
   String ChatterImageAttachmentURL3 = '&operationContext=CHATTER';
   String ChatterImageAttachmentURL2Big = '.content.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=';
   String Message;
   String PostImageURL; 
   String PostImageURLBig;
   /* 
    * Constructor: 1. Fetches Group Id, Refresh Time from the Custom Setting
    *              2. Creates a Map of User's Id & PhotoUrl
    *              3. Sets a flag if there is no Chatter Posts on the Group
    *              4. Fetches the instance the page is open on
    */
    
   public GNationLiveController() {
       //Get the Group Id & refresh time from the custom setting
       GNationLive = [Select Group_Id__c, Refresh_Time__c from GNationLive__c Limit 1];
       GNationGroup = GNationLive.Group_Id__c;
       RefreshTime = (Integer) GNationLive.Refresh_Time__c;
       
       //Check if there is any chatter posts in the group specified in the custom setting
       ChatterPosts = [Select Id, Body, CreatedById, CreatedBy.Name, Parent.Name, ParentId, CreatedDate from FeedItem where ParentId =:GNationGroup];
       listUser = [Select Id, FullPhotoUrl from User where isActive=true];
       
       //Create a map of Id & photo Url of the user
       for(integer i =0; i <listUser.size(); i++){
           MapIdPhotoUrl.put(listUser[i].Id, listUser[i].FullPhotoUrl);
       }
      
       //Set a check flag
       if(ChatterPosts.size () > 0)
           nofeeds = false;
       else
           nofeeds = true;
           
       //Fetch the instance
       String[] baseURL = URL.getSalesforceBaseUrl().toExternalForm().split('/');
       String instanceURL  = baseURL[2];
       String[] instanceName = instanceURL.split('.visual.force.com');
       instance = instanceName[0];
   }

   /*
    * This method: 1. Gets Chatter Posts & the posts info
    *              2. Grabs PhotoUrl from the MapIdPhotoUrl
    *              3. Creates another object 'GNationGroupUpdateObject'
    */
    
   public list<GNationGroupUpdateObject> getGNationLivePosts(){
       List <GNationGroupUpdateObject> updates = new List <GNationGroupUpdateObject>();
       if(nofeeds == false){
           FeedItem[] feeds;
           try{
               feeds = [Select Id, Body, CreatedById, CreatedBy.Name, Parent.Name, ParentId, CreatedDate, RelatedRecordId, ContentType from FeedItem where ParentId =:GNationGroup Limit 25];
           }
           catch(System.QueryException e){
               return updates;
           }
           
           for(FeedItem feed : feeds){
               String PhotoUrl = MapIdPhotoUrl.get(feed.CreatedById);
               
               //Time Difference
               DateTime currentTime = datetime.now();
               DateTime postedTime = feed.CreatedDate;
               
               double timeDiff = currentTime.getTime() - postedTime.getTime();
               double convertedSecs = timeDiff/1000;
               String timeAgo;
               Integer roundConvertedHours;
               Integer roundConvertedDays;
               
               if(convertedSecs < 60){
                   timeAgo = String.valueOf((integer)convertedSecs) +' secs';
               }
               
               double convertedMins = convertedSecs/60;
               Integer roundConvertedMins = (integer) convertedMins;
               if(ConvertedSecs >60 && roundConvertedMins < 2)
                  timeAgo = '1 min';
                  
               if(roundConvertedMins == 2)
                   timeAgo = '2 mins';
                      
               if(roundConvertedMins > 2 && roundConvertedMins < 60)
                  timeAgo = String.valueOf(roundConvertedMins)+' mins';
                   
             if(roundConvertedMins > 60){
                   roundConvertedHours = roundConvertedMins/60;
                   
                   if(roundConvertedHours < 2){
                       timeAgo = '1 hour';
                   }
         
                   if(roundConvertedHours == 2 || (roundConvertedHours > 2 && roundConvertedHours < 24)){
                       timeAgo = String.valueOf(roundConvertedHours)+ ' hours'; 
                   }
                   
                   if(roundConvertedHours == 24){
                       timeAgo = '1 day';
                   }
                   
                   if(roundConvertedHours > 24){
                       roundConvertedDays = roundConvertedHours/24;
                       if(roundConvertedDays == 1)
                           timeAgo = '1 day';
                       else
                           timeAgo = String.valueOf(roundConvertedDays)+ ' days';
                   }
               }
               
               /*
                * This checks if the User posted an image, if yes it captures the Image 
                *
                */
               if(feed.relatedRecordID != null){
                 String contentType = feed.ContentType;
                   if(contentType.contains('image')){
                       PostImageURL = 'https://'+instance+ChatterImageAttachmentURL2+feed.RelatedRecordId+ChatterImageAttachmentURL3;
                       PostImageURLBig = 'https://'+instance+ChatterImageAttachmentURL2Big+feed.RelatedRecordId+ChatterImageAttachmentURL3;
                   }
               }
               else{
                   PostImageURL = '';
                   PostImageURLBig = '';
               } 

              //Check if the body is longer than 400 characters
              if(feed.body != null){ 
               if(feed.body.length() >=400){
                   message = feed.body.substring(0,399)+'...';
               } 
               else
                   message = feed.body;
              }
                    
             /*
              * Post will only be displayed if there is a body
              */  
               if(feed.body != null)
                   updates.add(new GNationGroupUpdateObject(feed.CreatedBy.Name, feed.CreatedById, feed.Parent.Name, feed.ParentId, message, PhotoUrl, timeAgo, GNationGroup, PostImageURL, PostImageURLBig));
           }
           return updates;
       }
       else
           return null;
   }
   
   /*
    *  This method: 1. Its the action component of action poller
    *               2. Calls the getGNationLivePosts method to return all the chatter posts
    */
    
   public PageReference RefreshPosts() {
        getGNationLivePosts();
        return null;
   }
    
   /* This method: 1. Dynamically fetches refresh time from the custom setting
    *              2. Returns the refresh time to the action poller method 
    */   
   public Integer getRefreshTime() {
        return RefreshTime;
    }
}