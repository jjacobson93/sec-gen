extern crate base64;
extern crate rand;

use rand::Rng;

const DEFAULT_NBYTES: usize = 32;

pub fn token_bytes(nbytes: Option<usize>) -> Vec<u8> {
    let mut rng = rand::thread_rng();
    let nbytes = nbytes.unwrap_or(DEFAULT_NBYTES);
    let mut bytes = vec![];
    for _ in 0..nbytes {
        bytes.push(rng.gen::<u8>());
    }
    bytes
}

pub fn token_hex(nbytes: Option<usize>) -> String {
    token_bytes(nbytes)
        .iter()
        .map(|b| format!("{:02x}", b))
        .collect::<Vec<_>>()
        .join("")
}

pub fn token_urlsafe(nbytes: Option<usize>) -> String {
    let bytes = token_bytes(nbytes);
    base64::encode(&bytes)
        .replace("+", "-")
        .replace("/", "_")
        .trim_right_matches("=")[..bytes.len()]
        .to_string()
}
