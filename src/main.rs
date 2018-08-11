#[macro_use]
extern crate clap;
use clap::{App, Arg};

extern crate secgen;

fn main() {
    let matches = App::new("sec-gen")
        .version(crate_version!())
        .about("Generate secrets")
        .arg(
            Arg::with_name("url-safe")
                .short("u")
                .long("url-safe")
                .help("Outputs the secret as a base64 string"),
        )
        .arg(
            Arg::with_name("LENGTH")
                .index(1)
                .required(false)
                .help("Number of bytes"),
        )
        .get_matches();

    let nbytes = value_t!(matches, "LENGTH", usize).ok();

    let s = if matches.is_present("url-safe") {
        secgen::token_urlsafe(nbytes)
    } else {
        secgen::token_hex(nbytes)
    };

    println!("{}", s);
}
