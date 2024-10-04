bool checkCollision(player, block) {
  if (player.x < block.x + block.width &&
      player.x + player.width > block.x &&
      player.y < block.y + block.height &&
      player.y + player.height > block.y) {
    return true;
  }
  return false;
}
