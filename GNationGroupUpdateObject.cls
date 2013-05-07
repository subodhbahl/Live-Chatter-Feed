public with sharing class GNationGroupUpdateObject {
    
    static final String PROFILE_PAGE = '/_ui/core/userprofile/UserProfilePage?u=';
    static final String GROUP_PAGE = '/_ui/core/chatter/groups/GroupProfilePage?g=';

    public GNationGroupUpdateObject(){}
    
    public GNationGroupUpdateObject(String fromName, String fromId, String toName, String toId, String message, String PhotoUrl, String timeDiff, String GroupId, String ChatterImageURL, String ChatterImageURLBig){
        this.fromId = fromId;
        this.toId = toId;
        this.fromName = fromName;
        this.toName = toName;
        this.message = message;
        this.PhotoUrl = PhotoUrl;
        this.timeDiff = timeDiff; 
        this.GroupId = GroupId;
        this.ChatterImageURL = ChatterImageURL; 
        this.ChatterImageURLBig = ChatterImageURLBig;
    }
 
    public String fromName {get; set;}
    public String fromId {get; set;}  
    public String toName {get; set;}
    public String toId {get; set;}
    public String message{get; set;}
    public String GroupId {get; set;}
    public String ChatterImageURL {get; set;}
    public String ChatterImageURLBig {get; set;}
    public String getFromLink(){
        return PROFILE_PAGE + fromId;
    }
    public String getToLink(){
        return GROUP_PAGE + toId;
    }
    public String PhotoUrl {get; set;}
    public String timeDiff {get; set;}
    
    public String getJSON(){
        return 'feed= { "fromName": "' + fromName + '", "fromId": "'+ PROFILE_PAGE + fromId +'" , "toName" : "' + toName + '", "toId" : "' + GROUP_PAGE + toId +'", "message" : "' + message + '", "photourl" : "' + PhotoUrl + '", "time" : "' + timeDiff + '", "Image" : "' + ChatterImageURL + '", "ImageBig" : "' + ChatterImageURLBig + '" }';
    }
}