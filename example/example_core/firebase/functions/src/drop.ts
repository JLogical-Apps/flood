declare namespace UserRepository {
  const path: 'user';
}
declare namespace TodoRepository {
  const path: 'todo';
}
declare namespace TagsRepository {
  const path: 'tags';
}
declare namespace PublicRepository {
  const path: 'public';
}
declare namespace User {
  const nameField: 'name';
  const emailField: 'email';
  const deviceTokenField: 'deviceToken';
  const profilePictureField: 'profilePicture';
  const creationTimeField: 'creationTime';
}
declare namespace UserToken {
  const nameField: 'name';
  const assetField: 'asset';
}
declare namespace Todo {
  const nameField: 'name';
  const descriptionField: 'description';
  const completedField: 'completed';
  const tagsField: 'tags';
  const userField: 'user';
  const assetsField: 'assets';
  const tokensField: 'tokens';
  const creationTimeField: 'creationTime';
}
declare namespace Tag {
  const nameField: 'name';
  const colorField: 'color';
  const ownerField: 'owner';
}
declare namespace PublicSettings {
  const minVersionField: 'minVersion';
}