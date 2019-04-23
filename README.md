# bubble
Open source social network.

## About
Bubble is a social network providing text, video, and photo support
(eventually may support realtime chat).

## Organization
Bubble's organization is something of a fusion of Reddit and Twitter.

* A *post* is an entity containing some sort of text, link, or multimedia content.
* A *user* is an entity, typically a human being, to whom posts can be attributed.
* A *bubble* is, simply put, a timeline or grouping of posts. Bubbles exist independently of each other.
    * Users can *subscribe* to a bubble.
        * Each *subscription* has a permission attached to it - `owner`, `admin`, `moderator`,
        `canPost`, `commentOnly`, `readOnly`, or `banned`. These are self-explanatory, and determine what
        a user can do within the scope of a single bubble.
    * Each user is the owner of a special *profile bubble*. In this bubble, only said user can create
    posts. Other users can, however, repost or comment on content created by other users.
    * A post can be *shared* to any number of bubbles.
    * Special *aggregate bubbles* automatically receive posts shared to the bubbles they consist of.
        * Each user has a special aggregate bubble that consists of posts shared by users that they follow.