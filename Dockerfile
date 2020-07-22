FROM ubuntu:18.04
MAINTAINER pas-valkov <pas-valkov@yandex.ru>

ENV SAMTOOLS_VERSION 1.10
ENV LIBDEFLATE_VERSION 1.6
ENV ZLIB_VERSION 1.2.11
ENV LZMA_VERSION 5.2.5
ENV NCURSES_VERSION 6.2
ENV BZIP2_VERSION 1.0.8
ENV CURL_VERSION 7.71.1
ENV WORKSPACE /SOFT

RUN apt-get update \
	&& apt-get install --yes build-essential

WORKDIR /SOFT/download

RUN apt-get install --yes wget

#ncurses5	
RUN wget -O - "https://ftp.gnu.org/gnu/ncurses/ncurses-${NCURSES_VERSION}.tar.gz" | tar -xzf - \
	&& cd ncurses-${NCURSES_VERSION} \
	&& ./configure --prefix=${WORKSPACE} \
	&& make \
	&& make install 

#zlib	
RUN wget -O - "https://zlib.net/zlib-${ZLIB_VERSION}.tar.gz" | tar -xzf - \
	&& cd zlib-${ZLIB_VERSION} \
	&& ./configure --prefix=${WORKSPACE} \
	&& make \
	&& make install 

#libdeflate
RUN wget -O - "https://github.com/ebiggers/libdeflate/archive/v${LIBDEFLATE_VERSION}.tar.gz" | tar -xzf - \
	&& make -C libdeflate-${LIBDEFLATE_VERSION} 
ENV CPATH="${WORKSPACE}/download/libdeflate-${LIBDEFLATE_VERSION}:${CPATH}"

#lzma
RUN wget -O - "https://tukaani.org/xz/xz-${LZMA_VERSION}.tar.gz" | tar -xzf - \
	&& cd xz-${LZMA_VERSION} \
	&& ./configure --prefix=${WORKSPACE} \
	&& make \
	&& make install 

#bzlib2
RUN wget -O - "https://sourceware.org/pub/bzip2/bzip2-${BZIP2_VERSION}.tar.gz" | tar -xzf - \
	&& cd bzip2-${BZIP2_VERSION} \
	&& make install PREFIX=${WORKSPACE}

#curl
RUN wget -O - "https://curl.haxx.se/download/curl-${CURL_VERSION}.tar.gz" | tar -xzf - \
	&& cd curl-${CURL_VERSION} \
	&& make
ENV CPATH="${WORKSPACE}/download/curl-${CURL_VERSION}/include:${CPATH}"

ENV CPATH="${WORKSPACE}/include:${CPATH}"
ENV LDFLAGS="-L${WORKSPACE}/lib"

#samtools
RUN wget -O - "https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2" | tar -xvjf - \
    && cd samtools-${SAMTOOLS_VERSION} \
    && ./configure --prefix=${WORKSPACE} \
    && make install

ENV PATH="${WORKSPACE}/bin:${PATH}"