// Constants. 


let APIKey = "f11688d9fc777acfb94a22ddd0077381"
let GalaryIDKey = "72157673220222946"

let galaryListURL = "https://api.flickr.com/services/rest/?method=flickr.galleries.getPhotos&api_key=\(APIKey)&gallery_id=\(GalaryIDKey)&format=json&nojsoncallback=1"


let photoURL = "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=\(APIKey)&photo_id=%@&format=json&nojsoncallback=1"

// MARL: - 

let ImageDetailSegueIdentifier = "ImageDetailSegueIdentifier"

let ImageViewIdentifier = "ImageViewIdentifier"

let PlaceholderImage = "PlaceHolderImage.png"

let TitleKey = "title"
let ContentKey = "_content"
let OriginalformatKey = "originalformat"
let ViewsKey = "views"
let PhotoKey = "photo"
let PhotosKey = "photos"
let TotalKey = "total"
let IdKey = "id"
let FarmKey = "farm"
let ServerKey = "server"
let SecretKey = "secret"

let NoImageString = "There are 0 Images in this Gallary."
let ErrorStringMessage = "Something went wrong, Handle the error properly."

let width = 100.0
let height = 100.0