# CloudPhotos

## What's in this project

1. The SwiftData + CloudKit configuration
    - Includes a simplified data model that consists of an ID and a generated thumbnail
    - Actual photo is stored on the disk via iCloud Documents
1. Photo grid view
    - A simple mechanism to import photos from the Photos app is provided to populate this view with photos
1. Photo label view
    - Responsible for loading its own thumbnail from the data model
    - Includes a mechanism that hides the photo from the view hierarchy when the view is scrolled out of the visible area to save memory
1. Photo viewer overlay view
    - Responsible for loading the full size image from disk
    - Uses a mechanism that also attempts to wait for an iCloud Documents file to be downloaded when it is not downloaded locally

## Building

1. Clone the repository and open it in Xcode.
1. Change the bundle identifier.
1. Configure signing and the iCloud container that will be used.
1. Build and run the project.

## Known issues
- Opening/closing the photo viewer may freeze the app
