func permutate( word: [String], pointer: Int ){
  if pointer == word.count {
    print(word);
  }
  else{     
      var array = word
      permutate( word: array, pointer: pointer+1)
    for i in pointer..<word.count {
      if i != pointer {
        swap(&array[pointer], &array[i])
        permutate( word: array, pointer: pointer+1)
        swap(&array[pointer], &array[i])
      }
      
    }
  }
}


var array = ["a", "b", "c", "d"];
permutate( word: array, pointer: 0)