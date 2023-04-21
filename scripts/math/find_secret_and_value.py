import multiprocessing

# system constants
g = 2
r = 91
c = 561
# q = 9223372036854775783
q = 999983
qq = 3000029


def f(x, g, q, r):
    z1 = 505029767524228753
    z2 = 815122959970857316
    return (pow(g, z1, q)*pow(g, z2, q)) % q == pow(g, r * x, q)

def search_fake_value(work_queue, result_queue, found):
    while True:
        chunk = work_queue.get()
        for x in chunk:
            if f(x, g, q, r):
                result_queue.put(x)
                found.value = 1
                return
            if found.value:
                return

if __name__ == '__main__':
    num_processes = multiprocessing.cpu_count()
    result_queue = multiprocessing.Queue()
    found = multiprocessing.Manager().Value('i', 0)
    work_queue = multiprocessing.Queue()
    chunk_size = 100000
    max_value = chunk_size * num_processes

    for i in range(num_processes):
        start = i * chunk_size + 1
        end = (i+1) * chunk_size + 1
        chunk = list(range(start, end))
        work_queue.put(chunk)

    processes = [multiprocessing.Process(target=search_fake_value, args=(work_queue, result_queue, found)) for i in range(num_processes)]
    for process in processes:
        process.start()

    while True:
        if not result_queue.empty():
            result = result_queue.get()
            print(f"The fake value is {result}")
            for p in processes:
                p.terminate()
            break
        if all(p.is_alive() == False for p in processes):
            break
        while not work_queue.empty():
            pass
        print("Starting a new set!")
        for i in range(num_processes):
            start = i * chunk_size + 1
            end = (i+1) * chunk_size + 1
            chunk = list(range(start, end))
            work_queue.put(chunk)

    