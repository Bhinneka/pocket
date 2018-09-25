# Pocket

#### An Experimental In Memory Key Value written in Elixir built on top of GenServer and TCP protocol

# Note !!!
#### this project is only for the purpose of having fun with Elixir's GenServer and Elixir's Map :stuck_out_tongue_winking_eye:

### Todo
- Add `DEL` (delete command by specific index)
- Add more data type support
- More error handling

## Installation

Clone Pocket

```shell
$ git clone https://github.com/Bhinneka/pocket
```

Compile Pocket
```shell
$ iex -S mix
```

## Usage
Run Pocket
```shell
iex(1)> Pocket.start([], [])
```

Open new terminal
```
$ telnet 127.0.0.1 9000
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
```

Add new value
```shell
SET a andi
OK
GET a
andi
```


#### Author
Wuriyanto https://github.com/wuriyanto48

##

### Bhinneka.com 2018