// GENERATED CODE - DO NOT MODIFY BY HAND
declare module 'bubble' {
  interface Bubble {
    id?: string;
    type: any;
    owner_id?: number;
    name: string;
    description: string;
    shares?: PostShare[];
    aggregation_rules?: BubbleAggregationRule[];
    created_at?: any;
    updated_at?: any;
  }
  interface BubbleAggregationRule {
    id?: string;
    bubble_id?: number;
    target_bubble_id?: number;
    target_user_id?: number;
    created_at?: any;
    updated_at?: any;
  }
  interface Post {
    id?: string;
    type: any;
    user?: User;
    created_at?: any;
    updated_at?: any;
  }
  interface PostShare {
    bubble_id: number;
    user?: User;
    post?: Post;
  }
  interface Subscription {
    bubble?: Bubble;
    user?: User;
    permission: any;
  }
  interface User {
    id?: string;
    username: string;
    salt: string;
    hashed_password: string;
    is_email_confirmed?: boolean;
    is_avatar_verified?: boolean;
    created_at?: any;
    updated_at?: any;
  }
}