enum Direction: Int
{
  case Free=1, NotAllowed, Exit
}
var array=[["0","0","1","1"],
           ["1","0","1","0"],
           ["1","0","0","1"],
           ["1","1","0","2"]]

func checkPosition(array: inout [[String]], row: Int, col: Int) -> Direction{
  if row > array.count-1 || row < 0 || col > array[0].count-1 || col < 0 || array[row][col] == "1" {
    return Direction.NotAllowed
  }
  if array[row][col] == "0" {
    return Direction.Free
  }
  if array[row][col] == "2" {
    return Direction.Exit
  }
  return Direction.NotAllowed
}

func findPath(array: inout [[String]], path: inout [(row: Int, col: Int)], row: Int, col: Int) -> Bool {
  if path.index(where: { $0.row == row && $0.col == col }) != nil {
    return false;
  }
  path.append((row: row, col: col))
  switch checkPosition(array: &array, row: row, col: col) {
    case Direction.Free:
      //print(Direction.Free);
      return findPath(array: &array, path: &path, row: row+1, col: col) ||
             findPath(array: &array, path: &path, row: row-1, col: col) ||
             findPath(array: &array, path: &path, row: row, col: col+1) ||
             findPath(array: &array, path: &path, row: row, col: col-1) 
      //print((row: row, col: col));
    case Direction.NotAllowed:
    return false;
    case Direction.Exit:
      //print(Direction.Exit);
      return true;
  }
  //print("Not found");
  return false;
}
var path: [(row: Int, col: Int)]=[];
print(findPath(array: &array, path: &path, row: 0, col: 0));